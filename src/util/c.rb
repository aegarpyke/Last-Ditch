module C

	TITLE = 'Last Ditch'

	BTW, WTB = 32.0, 32.0**-1
	BOX_STEP = 1/60.0
	MAX_STEPS = 5
	BOX_VEL_ITER, BOX_POS_ITER = 6, 2

	WIDTH, HEIGHT = 800, 600
	MAP_WIDTH, MAP_HEIGHT = 400, 400

	BASE_SLOTS = 16
	INVENTORY_SLOTS = 32
	PLAYER_SPD = 2.0
	PLAYER_ROT_SPD = 6.0

	BIT_PLAYER = 2
	BIT_LIGHT = 4
	BIT_WALL = 8
	BIT_WINDOW = 16
	BIT_ENTITY = 32

	ITEMS = [
		'overgrowth1', 'handgun1', 'scrap1',
		'rations1_empty', 'rations1', 
		'canteen1_empty', 'canteen1_water', 
		'canister1_empty', 'canister1_water', 'canister1_waste', 'canister1_fuel']

end