extends HBoxContainer

const RESOURCE = {
	0: "Aluminium",
	1: "Cuprum",
	2: "Argentum",
	3: "Aurum",
	4: "Rhodium",
	5: "Sapphirus",
	6: "Rubinus",
	7: "Smaragdus",
	8: "Veritasium",
	9: "Eternium"
}

func _on_item_1_item_selected(selected_index):
	if $Item2.get_selected() == selected_index:
		$Item2.select((selected_index + 1) % $Item2.item_count)
	var exchange_rates = Exchange.exchange_rates(RESOURCE[$Item1.get_selected()], RESOURCE[$Item2.get_selected()])
	$Amounts1/Item1.text = str(exchange_rates[0])
	$Amounts2/Item1.text = str(exchange_rates[1])
	$Amounts1/Item2.text = str(exchange_rates[2])
	$Amounts2/Item2.text = str(exchange_rates[3])

func _on_item_2_item_selected(selected_index):
	if $Item1.get_selected() == selected_index:
		$Item1.select((selected_index + 1) % $Item1.item_count)
	var exchange_rates = Exchange.exchange_rates(RESOURCE[$Item2.get_selected()], RESOURCE[$Item1.get_selected()])
	$Amounts2/Item1.text = str(exchange_rates[0])
	$Amounts1/Item1.text = str(exchange_rates[1])
	$Amounts2/Item2.text = str(exchange_rates[2])
	$Amounts1/Item2.text = str(exchange_rates[3])
