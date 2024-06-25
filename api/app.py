from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/player_data', methods=['POST'])
def player_data():
    user_id = request.json.get('user_id')
    if user_id:
        response = {
          "commander": {
            "name": "Joe",
            "experience": 0,
            "pilot_ability_multiplier": 1,
            "ship_ability_multiplier": 1,
            "graze_power_multiplier": 1,
            "shot_power_multiplier": 1,
            "device_effect_multiplier": 1,
            "perfect_chance_multiplier": 1,
            "perfect_multiplier": 1,
            "exchange_multiplier": 1,
            "magnet_multiplier": 1,
            "luck_multiplier": 1
          },
          "player_ship": {
            "Virtue": {
              "main_shot_rate_level": 5,
              "main_shot_speed_level": 0,
              "main_shot_power_level": 0,
              "ship_ability_level": 0,
              "movement_speed_level": 0,
              "graze_area_radius_level": 1,
              "cannons": ["Ballistic", "Ballistic"]
            },
            "Justice": {
              "main_shot_rate_level": 5,
              "main_shot_speed_level": 0,
              "main_shot_power_level": 0,
              "ship_ability_level": 0,
              "movement_speed_level": 0,
              "graze_area_radius_level": 1,
              "cannons": ["Plasma", "Plasma"]
            },
            "Excalibur": {
              "main_shot_rate_level": 5,
              "main_shot_speed_level": 0,
              "main_shot_power_level": 0,
              "ship_ability_level": 0,
              "movement_speed_level": 0,
              "graze_area_radius_level": 1,
              "cannons": ["Plasma", "Plasma"]
            }
          },
          "pilot": {
            "Lance": {
              "max_cannons": 3,
              "max_devices": 0,
              "maneuver_level": 1,
              "pilot_ability_level": 1,
              "graze_area_radius_multiplier": 1,
              "graze_power_level": 1,
            },
            "Mia": {
              "max_cannons": 1,
              "max_devices": 0,
              "maneuver_level": 1,
              "pilot_ability_level": 1,
              "graze_area_radius_multiplier": 1,
              "graze_power_level": 1,
            }
          },
          "asset": {
            "Aluminium": 100,
            "Cuprum": 0,
            "Argentum": 0,
            "Aurum": 0,
            "Rhodium": 0,
            "Sapphirus": 0,
            "Rubinus": 0,
            "Smaragdus": 0,
            "Veritasium": 0,
            "Eternium": 1,
          },
          "selected_player_ship": "Justice",
          "selected_pilot": "Lance",
          "levels": {
            "1": 10,
            "2": 9,
            "3": 8,
            "4": 7,
            "5": 6,
            "6": 5,
            "7": 4,
            "8": 3,
            "9": 2,
            "10": 1,
            "11": 0
          }
        }
        return jsonify(response), 200
    else:
        return jsonify({"error": "user_id is required"}), 400

if __name__ == '__main__':
    app.run(debug=True)

