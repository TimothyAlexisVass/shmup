extends HBoxContainer

func _ready():
	$Item1.select(0)
	$Item2.select(1)
	_on_item_1_item_selected(0)
	_on_item_2_item_selected(1)

func _on_item_1_item_selected(selected_index):
	if $Item2.get_selected() == selected_index:
		$Item2.select((selected_index + 1) % $Item2.item_count)
	var exchange_rates = Exchange.exchange_rates(Exchange.resources[$Item1.get_selected()], Exchange.resources[$Item2.get_selected()])
	$Amounts1/From.text = exchange_rates[0]
	$Amounts2/To.text = exchange_rates[1]
	$Amounts1/To.text = exchange_rates[2]
	$Amounts2/From.text = exchange_rates[3]
	set_visibility()

func _on_item_2_item_selected(selected_index):
	if $Item1.get_selected() == selected_index:
		$Item1.select((selected_index + 1) % $Item1.item_count)
	var exchange_rates = Exchange.exchange_rates(Exchange.resources[$Item2.get_selected()], Exchange.resources[$Item1.get_selected()])
	$Amounts1/From.text = exchange_rates[3]
	$Amounts2/To.text = exchange_rates[2]
	$Amounts1/To.text = exchange_rates[1]
	$Amounts2/From.text = exchange_rates[0]
	set_visibility()

func set_visibility():
	$Amounts1/From.set_visible(true)
	$Amounts1/To.set_visible(true)
	$Amounts2/To.set_visible(true)
	$Amounts2/From.set_visible(true)
	$HBoxContainer/Item1ToItem2.set_visible(true)
	$HBoxContainer/Item2ToItem1.set_visible(true)
	if $Amounts1/From.text == "0":
		$Amounts1/From.set_visible(false)
		$Amounts2/To.set_visible(false)
		$HBoxContainer/Item1ToItem2.set_visible(false)
	if $Amounts2/From.text == "0":
		$Amounts2/From.set_visible(false)
		$Amounts1/To.set_visible(false)
		$HBoxContainer/Item2ToItem1.set_visible(false)

func _on_item_1_to_item_2_pressed():
	perform_exchange(
		Exchange.resources[$Item1.get_selected()],
		Exchange.resources[$Item2.get_selected()],
		-resource_weight_to_float($Amounts1/From.text),
		resource_weight_to_float($Amounts2/To.text)
	)

func _on_item_2_to_item_1_pressed():
	perform_exchange(
		Exchange.resources[$Item2.get_selected()],
		Exchange.resources[$Item1.get_selected()],
		-resource_weight_to_float($Amounts2/From.text),
		resource_weight_to_float($Amounts1/To.text)
	)

func resource_weight_to_float(weight):
	var factor = 1
	if weight.ends_with("mg"):
		factor = 0.001
	elif weight.ends_with("kg"):
		factor = 1_000
	elif weight.ends_with("t"):
		factor = 1_000_000
	return snapped(float(weight) * factor, 0.001)

func perform_exchange(resource_from, resource_to, amount_from, amount_to):
	if DataManager.player_data.resources[resource_from] >= amount_from:
		DataManager.player_data.resources[resource_from] -= amount_from
		DataManager.player_data.resources[resource_to] += amount_to
	DataManager.player_data.resources[resource_from] = snapped(DataManager.player_data.resources[resource_from], 0.01)
	DataManager.player_data.resources[resource_to] = snapped(DataManager.player_data.resources[resource_to], 0.01)
	DataManager.save_data()
	G.modals.update_resource_values()
