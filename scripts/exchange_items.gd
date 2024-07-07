extends HBoxContainer

@onready var from = Exchange.all[$AssetFrom.get_selected()]
@onready var to = Exchange.all[$AssetTo.get_selected()]

func _on_item_1_item_selected(selected_index):
	if $AssetTo.get_selected() == selected_index:
		$AssetTo.select((selected_index + 1) % $AssetTo.item_count)
	update_exchange_values()

func _on_item_2_item_selected(selected_index):
	if $AssetFrom.get_selected() == selected_index:
		$AssetFrom.select((selected_index + 1) % $AssetFrom.item_count)
	update_exchange_values()

func update_exchange_values():
	to = Exchange.all[$AssetTo.get_selected()]
	from = Exchange.all[$AssetFrom.get_selected()]
	var to_selected = $AssetTo.get_selected()
	$AssetTo.clear()
	var exchangeable = 9
	if from in Exchange.metal:
		exchangeable = 5
	elif from in (Exchange.gem + ["Veritasium"]):
		exchangeable = 8
	for i in range(exchangeable):
		$AssetTo.add_icon_item(Asset.data[Exchange.all[i]].texture, "", i)
		if i == $AssetFrom.get_selected():
			$AssetTo.set_item_disabled(i, true)
		elif i == to_selected:
				$AssetTo.select(to_selected)

	var exchange_rates = Exchange.exchange_rates(Exchange.all[$AssetFrom.get_selected()], Exchange.all[$AssetTo.get_selected()])
	if exchange_rates == null:
		$AmountFrom.set_visible(false)
		$AmountTo.set_visible(false)
		$PerformExchange.set_visible(false)
	else:
		$AmountFrom.text = exchange_rates.from
		$AmountTo.text = "+" + exchange_rates.to
		$AmountFrom.set_visible(true)
		$AmountTo.set_visible(true)
		$PerformExchange.set_visible(true)
		$PerformExchange.set_disabled(exchange_rates.disable)

func _on_item_1_to_item_2_pressed():
	perform_exchange(from, to, -asset_weight_to_float($AmountFrom.text))

func asset_weight_to_float(weight):
	var factor = 1
	if weight.ends_with("mg"):
		factor = 0.001
	elif weight.ends_with("kg"):
		factor = 1_000
	elif weight.ends_with("t"):
		factor = 1_000_000
	return snapped(float(weight) * factor, 0.001)

func perform_exchange(asset_from, asset_to, amount_from):
	Api.perform_exchange(asset_from, asset_to, amount_from)

func _on_visibility_changed():
	update_exchange_values()
