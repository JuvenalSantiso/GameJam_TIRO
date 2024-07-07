extends Node2D


func _process(delta):
	# Prints a random floating-point number from a normal distribution with a mean 0.0 and deviation 1.0.
	var random = RandomNumberGenerator.new()
	random.randomize()
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(random.randfn()).timeout
	$GPUParticles2D2.emitting = true
	await get_tree().create_timer(random.randfn()+0.2).timeout
	$GPUParticles2D3.emitting = true
	await get_tree().create_timer(random.randfn()+0.2).timeout
	$GPUParticles2D4.emitting = true
	await get_tree().create_timer(random.randfn()+0.2).timeout
	$GPUParticles2D5.emitting = true
	await get_tree().create_timer(random.randfn()+0.2).timeout
