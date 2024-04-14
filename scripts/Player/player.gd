class_name Player extends CharacterBody2D


var allow_attack_0:bool = true
var allow_attack_1:bool = true
var allow_attack_2:bool = true
var allow_attack_3:bool = true

var player_health = 100
func hit_player(damage):
	if currentAction == 4:
		return
	currentAction = 4 #stun action
	var index = timedActionNumber.find(currentAction)
	timedActionCooldown[index] = timedActionDefaultCooldown[index]
	timedActionRemainingDuration = timedActionDuration[index]
	player_health -= damage
func reset(): #reset with animation
	currentPostResetFrames = postResetFrames
	resetting = true
	velocity = Vector2.ZERO
	animatedSprite.modulate = Color(1,1,1,0.5)
	initialResetSize = posOverTime.size()
	var x = $resetSound
	x.play()
	
func quick_reset(): #no animation
	var h = healthOverTime.pop_front()
	var p = posOverTime.pop_front()
	healthOverTime.clear()
	posOverTime.clear()
	healthOverTime.append(h)
	posOverTime.append(p)
	
	player_health = h
	position = p
	resetting = false
	velocity = Vector2.ZERO
	animatedSprite.modulate = Color(1,1,1,1)

# above are intended for public use ==========================================================
var healthOverTime:Array = []
var posOverTime: Array = []

var particles: CPUParticles2D
var resetting:bool = false
const accel = 40
const friction = 0.9125
const noInputFriction = 0.8
const responsivenessMultiplier = 3

var wishDir: Vector2 = Vector2.ZERO
var animatedSprite: AnimatedSprite2D

const animationsDir = [Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT,Vector2.UP] #lists the desired wishDir that fits the animation best
const animationNames = ["RunDown","RunLeft","RunRight","RunUp","IdleDown","IdleLeft","IdleRight","IdleUp","AttackDown","AttackLeft","AttackRight","AttackUp","SPINNYIDGAF","SPINNYIDGAF","SPINNYIDGAF","SPINNYIDGAF"]
const animationStride: int = 4 #total number of directions for animations

var currentAction: int = 0 # 0 for idle, 1 for run, further actions are timedActions and their properties and implimentations are below
var prevDir: Vector2 = Vector2.UP #used for determining idle directions

#timed action system, used for attacks and possibly dashes/dodges in the future
const timedActionNumber =         [2,3,4,5,6,7]   #refers to action number
const timedActionDuration =       [0.125,0.125,0.25,0.125,1,0.125]#in secconds
const timedActionDefaultCooldown =[1,2,0,1,2,3]
const timedActionAnimationPosition =  [3,4,5,3,6.3] #represents the index * stride
var timedActionCooldown =       [0,0,0,0,0,0]
var timedActionRemainingDuration = 0

const dashMaintain = 100
const dashImpulse = 1500

const resetTimeScale = 0.5 #negetive time scale in godot is weird, so i have avoided using it after testing
const ResetDurationDesired = 2.0 #the amount of time the reset should take
var initialResetSize = 0

var weaponHitbox: player_hitbox
const weaponDamage = [2,3,4,5]
@onready var trialParticles = $"AnimatedSprite2D/particle affects/trailParticles"
@onready var weaponParticles1: CPUParticles2D = $"AnimatedSprite2D/particle affects/WeaponParticles1"
@onready var audio1: AudioStreamPlayer2D = $sound1
@onready var theVeryImportantHappyBlackPixelAndHisVerySeriousParent_TheBigArrow_UsedForFullScreenAffectsWhenDie = $Camera2D/CanvasLayer/UI/ArrowBig
var currentFootstepCooldown = 0
const footstepCooldown = 0.4
const postResetFrames = 60
var currentPostResetFrames = 0

func _ready():
	Singleton.player_node = self
	animatedSprite = $AnimatedSprite2D
	posOverTime.append(position)
	healthOverTime.append(player_health)
	weaponHitbox = get_child(3) #get weapon hitbox, idk $ would not work i hate this
func _physics_process(delta):
	if resetting:
		Engine.time_scale = resetTimeScale
		handleResetting()
		return
	handleTimedActions(delta)
	handlePlayerMovement()
	handlePlayerAnimations()
	
	if Input.is_action_pressed("SECRET_TEST_BUTTON_SHHH_TELL_NOBODY"):
		hit_player(10)
	if player_health <= 0:
		player_health = 0
		reset()
	
	if Engine.time_scale != 1:
		Engine.time_scale = 1
	
	posOverTime.append(position)
	healthOverTime.append(player_health)
	
func handleResetting():
	if posOverTime.size() < 1 && currentPostResetFrames == 0:
		resetting = false
		animatedSprite.modulate = Color(1,1,1,1)
		Singleton.reset()
		theVeryImportantHappyBlackPixelAndHisVerySeriousParent_TheBigArrow_UsedForFullScreenAffectsWhenDie.visible = false
		return
	theVeryImportantHappyBlackPixelAndHisVerySeriousParent_TheBigArrow_UsedForFullScreenAffectsWhenDie.visible = true
	
	if(posOverTime.size() < 1):
		animatedSprite.animation = animationNames[3]
		currentPostResetFrames-=1
		return
	
	
	var pos
	var hlth
	var numFramesToSkip = ((initialResetSize /60)/ResetDurationDesired)
	while numFramesToSkip > 0 && posOverTime.size() > 2: #skip frames 
		pos = posOverTime.pop_back()
		hlth = healthOverTime.pop_back()
		numFramesToSkip-=1
	
	pos = posOverTime.pop_back()
	hlth = healthOverTime.pop_back()
	
	player_health = hlth
	position = pos

func handleTimedActions(delta):
	# map inputs to action
	if currentFootstepCooldown >= 0:
		currentFootstepCooldown -= delta
	
	
	if currentAction >= 2 && timedActionRemainingDuration <= 0:
		currentAction = 0 #finnish 

	var desiredAction: int = -1
	if Input.is_action_pressed("attack1")&& allow_attack_0:
		desiredAction = timedActionNumber[0]
		
	if Input.is_action_pressed("special"):
		desiredAction = timedActionNumber[1]
		
	if Input.is_action_pressed("attack2")&& allow_attack_1:
		desiredAction = timedActionNumber[3]
	
	if Input.is_action_pressed("attack3")&& allow_attack_2:
		desiredAction = timedActionNumber[4]
		
	if Input.is_action_pressed("attack4")&& allow_attack_3:
		desiredAction = timedActionNumber[5]
	
	#decrease cooldowns
	for i in range(timedActionCooldown.size()): #WHAT THE HELL IS THIS SHIT, THIS IS NOT THE FOR LOOP I KNOW AND LOVE
		if timedActionCooldown[i] > 0:          #I CANT BELIEVE IM SAYING THIS BUT I ACTUALLY MISS JAVA
			timedActionCooldown[i]-=delta       #TAKE ME HOME COUNTR TORAAAD TO HE PLACE WHWER BLENONNGGG WEST VERTINGA
	
	if timedActionRemainingDuration >= 0:
		timedActionRemainingDuration -= delta
		return
	
	if timedActionCooldown[timedActionNumber.find(desiredAction)] <= 0:
		#perform action
		if desiredAction == -1:
			return
		var index = timedActionNumber.find(desiredAction)
		currentAction = desiredAction
		timedActionCooldown[index] = timedActionDefaultCooldown[index]
		timedActionRemainingDuration = timedActionDuration[index]
	else :
		return
	match currentAction:
		3:
			velocity = wishDir*dashImpulse
		5: 
			weaponParticles1.color = Color.WHITE
			weaponHitbox.rad = 60
			weaponHitbox.length = 100
			var desireRot: Vector2 = wishDir
			if(desireRot == Vector2.ZERO):
				desireRot = prevDir
			weaponParticles1.emitting = true
			weaponParticles1.direction = desireRot
			weaponHitbox.updateRot(desireRot)
			weaponHitbox.resetSwing()
			weaponHitbox.slowFactor = 0
			var x = $attk2
			x.play()
		2:
			weaponHitbox.rad = 60
			weaponHitbox.length = 50
			var desireRot: Vector2 = wishDir
			if(desireRot == Vector2.ZERO):
				desireRot = prevDir
			weaponParticles1.emitting = false
			weaponParticles1.direction = desireRot
			weaponHitbox.updateRot(desireRot)
			weaponHitbox.resetSwing()
			weaponHitbox.slowFactor = 0
			var x = $attk1
			x.play()
		6:
			weaponHitbox.rad = 90
			weaponHitbox.length = 1
			var desireRot: Vector2 = wishDir
			if(desireRot == Vector2.ZERO):
				desireRot = prevDir
			weaponParticles1.emitting = false
			weaponParticles1.direction = desireRot
			weaponHitbox.updateRot(desireRot)
			weaponHitbox.resetSwing()
			weaponHitbox.slowFactor = 0
			var x = $attk3
			x.play()
		7:
			weaponHitbox.rad = 60
			weaponHitbox.length = 100
			var desireRot: Vector2 = wishDir
			if(desireRot == Vector2.ZERO):
				desireRot = prevDir
			weaponParticles1.emitting = true
			weaponParticles1.direction = desireRot
			weaponParticles1.color = Color.DARK_SLATE_BLUE
			weaponHitbox.updateRot(desireRot)
			weaponHitbox.resetSwing()
			weaponHitbox.slowFactor = 0.7
			var x = $attk4
			x.play()


func handlePlayerAnimations():
	if currentAction == 1 || currentAction == 0:
		if wishDir.length() == 0:
			currentAction = 0
			audio1.stop()
		else:
			currentAction = 1
			if(currentFootstepCooldown <= 0 ):
				audio1.play()
				currentFootstepCooldown =  footstepCooldown
	else:
		audio1.stop()
	#THERE IS NO SWITCH STATEMENT IN THIS GOD AWFUL LANGUAGE>?>???? LORD HAVE MERCY GET ME OUT
	#nevermind theres match, match deez??? deee
	animatedSprite.modulate = Color.WHITE
	match currentAction:
		0:
			animatedSprite.animation = animationNames[animationsDir.find(prevDir) + (animationStride * 1)] 
		1:
			var bestFit: Vector2 = Vector2.ZERO
			for dir in animationsDir:
				if dir.dot(wishDir) > bestFit.dot(wishDir):
					bestFit = dir
			animatedSprite.animation = animationNames[animationsDir.find(bestFit)]
			prevDir = bestFit
		2:
			weaponHitbox.tickHitbox(weaponDamage[1])
			
			animatedSprite.animation = animationNames[animationsDir.find(prevDir) + (animationStride * 2)] 
			animatedSprite.play( animationNames[animationsDir.find(prevDir) + (animationStride * 2)] )
			
		3:
			if wishDir != Vector2.ZERO:
				velocity += wishDir * dashMaintain
		4:
			animatedSprite.modulate = Color.RED # damage
		5:
			weaponHitbox.tickHitbox(weaponDamage[0])
			
			animatedSprite.animation = animationNames[animationsDir.find(prevDir) + (animationStride * 2)] 
			animatedSprite.play( animationNames[animationsDir.find(prevDir) + (animationStride * 2)] )
		6:
			weaponHitbox.tickHitbox(weaponDamage[2])
			animatedSprite.animation = animationNames[animationsDir.find(prevDir) + (animationStride * 3)] 
			animatedSprite.play( animationNames[animationsDir.find(prevDir) + (animationStride * 3)] )
		7:
			weaponHitbox.tickHitbox(weaponDamage[3])
			animatedSprite.animation = animationNames[animationsDir.find(prevDir) + (animationStride * 2)] 
			animatedSprite.play( animationNames[animationsDir.find(prevDir) + (animationStride * 2)] )
func handlePlayerMovement():
	wishDir.x = Input.get_axis("move_left","move_right")
	wishDir.y = Input.get_axis("move_forward","move_back")
	wishDir = wishDir.normalized()
	
	#if nothing pressed apply no input friction
	if wishDir.length() == 0:
		velocity *= noInputFriction
	else:
		#calculate multiplier to make things more responsive in opisite directions
		var multi = (wishDir * -1).dot( velocity.normalized() ) + 1.0
		multi = (multi * responsivenessMultiplier) + 1
		velocity += wishDir * accel * multi
		
	velocity *= friction
	move_and_slide()
	
