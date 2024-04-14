extends TextureButton

enum COMPLETION {NONE, BRONZE_1, BRONZE_2, BRONZE_3, SILVER_1, SILVER_2, SILVER_3, GOLD_1, GOLD_2, GOLD_3, PINNACLE}

@export var level: int = 1
@export var completion: COMPLETION = COMPLETION.NONE
