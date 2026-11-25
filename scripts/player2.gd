#const SPEED = 300.0          
#const JUMP_VELOCITY = -400.0 # Forza del salto (negativa perché in Godot 2D l'asse Y verso l'alto è negativo)

#func _physics_process(delta: float) -> void: # Funzione eseguita a ogni frame della fisica (di default 60 volte al secondo#)


	
	#if not is_on_floor(): # Controlla se il personaggio NON sta toccando il pavimento
		# Applica la gravità del progetto moltiplicata per 'delta' (il tempo trascorso dall'ultimo frame)
		# per rendere la caduta fluida e indipendente dagli FPS del computer
		#velocity = velocity + (get_gravity() * delta)
	
	# --- GESTIONE DEL SALTO ---
	# Se viene premuto il tasto di salto ("ui_accept", di default Spazio o Invio) E il personaggio è a terra
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# Applica una spinta istantanea verso l'alto sull'asse verticale (Y)
		#velocity.y = JUMP_VELOCITY

	# --- GESTIONE DEL MOVIMENTO ORIZZONTALE ---
	# Legge l'input delle frecce sinistra/destra restituendo un valore tra -1.0 (sinistra), 0.0 (fermo) e 1.0 (destra)
	# (Buona norma: in futuro sostituisci "ui_left"/"ui_right" con azioni personalizzate nella Mappa Input)
	#var direction := Input.get_axis("ui_left", "ui_right")
	
	#if direction:# Se c'è un input direzionale (direction è diverso da 0)
		# Imposta la velocità orizzontale (X) nella direzione premuta
		#velocity.x = direction * SPEED
	#else:
		# Se nessun tasto è premuto, riduce la velocità orizzontale verso 0 fino a fermare il personaggio
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#move_and_slide()# Applica effettivamente il vettore 'velocity' al personaggio, gestendo automaticamente collisioni e scivolamento sui muri/pavimenti


extends CharacterBody2D # Eredita le funzionalità di CharacterBody2D, il nodo di Godot ideale per personaggi controllati dal giocatore con fisica e collisioni

# Costanti che definiscono i parametri base del movimento (in pixel al secondo)
const SPEED = 110.0 # Velocità massima di camminata orizzontale

var last_direction: Vector2 = Vector2.RIGHT

@onready var aniamted_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

	#---------------------------------------------------------------------
	# Se avessi scritto solo "delta" e non "_delta" compariva nella sezione Debugger
	# un problema che è: 
	#W 0:00:00:952   GDScript::reload: The parameter "delta" is never used in the function "_physics_process()". If this is intended, prefix it with an underscore: "_delta".
	#<GDScript Error>UNUSED_PARAMETER
	#<GDScript Source>player2.gd:7 @ GDScript::reload()
	# In cui dice che il parametro Delta non viene mai utilizzato nella funzione fisica del processo, che è vero perché c'è già una variabile
	#---------------------------------------------------------------------

func _physics_process(_delta: float) -> void: #funzione principale del gioco
	process_movement() #chiamo la funzione process_movement()
	process_animation()
	move_and_slide()

	
	
	
	
	
func process_movement() -> void: # Ho separato questa funzione ed l'ho richiamata nella funzione principale del gioco come: process_movement()
	#var direction := Input.get_axis("ui_left", "ui_right")
	#L'operatore := dice a Godot di dedurre automaticamente il tipo di dato della variabile dal valore che le stai assegnando, bloccandolo per il resto del codice
	#Tipizzazione statica inferita: Godot capisce da solo che get_vector restituisce un Vector2 e imposta quel tipo al posto tuo.
	var direction := Input.get_vector("left", "right", "up", "down")
	#Vector2.ZERO è una costante predefinita (utilizzata principalmente in motori grafici come Godot Engine) che rappresenta un vettore bidimensionale con coordinate (0, 0). Equivale a scrivere Vector2(0, 0), ma rende il codice più leggibile e leggermente più veloce perché evita di creare una nuova istanza ogni volta.
	if direction != Vector2.ZERO:
		velocity = direction * SPEED #Quindi prendo la velocità del giocatore in questo caso SPEED e calcolo la direzione moltiplicata per la velocità
		last_direction = direction
	else: #altrimenti che non c'è direzione
		velocity = Vector2.ZERO #in tal caso il giocatore deve fermarsi. Quindi la velocità diventa un vettore 2.0


func process_animation() -> void:
		if velocity != Vector2.ZERO: 
			
			play_animation("run", last_direction)
		else:
			play_animation("idle", last_direction)


func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x != 0:
		aniamted_sprite_2d.flip_h = dir.x < 0;
		aniamted_sprite_2d.play(prefix + "_right")
	else:
		aniamted_sprite_2d.play(prefix + "_left")
		
		
	if dir.y < 0:
		aniamted_sprite_2d.play( prefix + "_up")
	elif dir.y > 0:
		aniamted_sprite_2d.play( prefix + "_down")
