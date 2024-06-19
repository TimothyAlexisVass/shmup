class_name OrderedDict

var dict = {}
var dict_keys = []
var ordered_by
var order

func _init(dictionary: Dictionary, order_by: Variant = null, ascdesc: String = "asc"):
	dict = dictionary
	dict_keys = dictionary.keys()
	ordered_by = order_by
	order = ascdesc
	if ordered_by:
		sort_keys()

func insert(key: String, value: Variant):
	if key not in dict:
		dict_keys.append(key)
	dict[key] = value

func erase(key: String):
	if key not in dict:
		return null
	dict.erase(key)
	dict_keys.erase(key)
	if ordered_by:
		sort_keys()
	return key

func keys() -> Array:
	return dict_keys

func values(sorted: bool = true) -> Array:
	if sorted:
		var ordered_values = []
		for key in dict_keys:
			ordered_values.append(dict[key])
		return ordered_values
	return dict.values()

func ordered() -> Array:
	var ordered_dict = []
	for key in dict_keys:
		ordered_dict.append([key, dict[key]])
	return ordered_dict

func asc(a: String, b: String) -> bool:
	assert(typeof(dict[a][ordered_by]) == typeof(dict[b][ordered_by]))
	return dict[a][ordered_by] < dict[b][ordered_by]

func desc(a: String, b: String) -> bool:
	assert(typeof(dict[a][ordered_by]) == typeof(dict[b][ordered_by]))
	return dict[a][ordered_by] > dict[b][ordered_by]

func sort_keys():
	dict_keys.sort_custom(asc if order == "asc" else desc)
