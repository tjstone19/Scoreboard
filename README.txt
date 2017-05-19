In order to demonstrate functionality, you need to create an account on pushers website: pusher.com.

Once you create an account go to the dashboard and create a new app.  Click on the app in the pusher dashboard.
Click on the "App Keys" tab and copy your app_id, key, and secret.

Locate the constants file under the utilities group in the xcode project.
Replace my app_id, key, and secret with your app_id, key, and secret.

Run the project on a simulator or device.

Go back to your pusher app and click on the "Debug Console" tab. 
Click the show event creator drop down menu.
Make sure the channel name is "test_channel" and the event name is "my_event".

Here are the following json objects that are sent from time to score to my app.  Copy/paste them one at a time into the event creator and click send event.

LIST OF GAMES

{"games" :[{"game_id":"156234","date":"2016-11-25","time":"22:30:00","location":"San Jose North","home_id":"1792","home_team":"Chieftains 3 ","away_id":"1792","away_team":"Chieftains 3 ","home_goals":null,"away_goals":null,"level_id":"233","level_name":"Adult Division 9","gtype_id":"7","gtype_name":"Practice","home_smlogo":"","away_smlogo":"","mod_time":"2016-11-23 15:53:38","rink_address":"1500 South 10th Street, San Jose CA 95112","length":"75","timezn":"America\/Los_Angeles","alias":null,"event_type":"0","season_id":"37"},{"game_id":"155935","date":"2016-11-27","time":"15:15:00","location":"San Jose North","home_id":"1201","home_team":"Angry Beavers ","away_id":"3321","away_team":"Natural Disasters 2 ","home_goals":null,"away_goals":null,"level_id":"229","level_name":"Adult Division 6B","gtype_id":"1","gtype_name":"Regular","home_smlogo":"","away_smlogo":"","mod_time":"2016-11-09 16:45:34","rink_address":"1500 South 10th Street, San Jose CA 95112","length":"75","timezn":"America\/Los_Angeles","alias":null,"event_type":"1","season_id":"37"}]}


SCOREBOARD EVENT

{"clock":"19:02","period":"Period 1","homep1":"19","homep2":"20","awayp1":"21","awayp2":"22","homescore":"1","awayscore":"2",
"homeshots":"3","awayshots":"4","hometeam":"Home","awayteam":"Away","game_id":"135944","homep1p":"1:30","homep2p":"1:29","awayp1p":"1:28",
"awayp2p":"1:27","rosters":"0","events":"0", "flags":"0","info":""}


PENALTY LIST (click penalty button on scoreboard)

{"event":"my_event", "data": {"clock":"01:11", "period":"Period 1", "homep1":"02:00", "homep2":" ", "awayp1":" ", "awayp2":" ", "homescore":" 1", "awayscore":" 2", "homeshots":" 4", "awayshots":"6", "hometeam":"Home", "awayteam":"Away", "game_id":"121250", "homep1p":"24", 
"homep2p":" ", "awayp1p":" ", "awayp2p":" ", "rosters":"0", "events":"0", "info":"Home K Richardson: Hooking (2:00)"}, "channel":"north"}

GOAL LIST (click home button on scoreboard)

{"event":"my_event","data":{"clock":"13:22","period":"Period 1","homep1":" ",
"homep2":" ","awayp1":" ","awayp2":" ","homescore":" 1","awayscore":" 0","homeshots":"1","awayshots":"0" ,"hometeam":"Home", "awayteam":"Away", "game_id":"121250","homep1p":" ", "homep2p":" ","awayp1p":" ","awayp2p":" ", "rosters":"0", "events":"0", "info":"Home Goal:A Dekeyrel,S Jameson,M Richardson"}, "channel":"north"}


ROSTER LIST (click info button next to home and away buttons on scoreboard)

{"home_players":[{"name":"Henry Welch","game_jersey":"14","goals":"0","assists":"0","pims":"0","player_id":"15576"},
{"name":"Kyle Welch","game_jersey":"23","goals":"0","assists":"0","pims":"0","player_id":"43778"},
{"name":"Paul Nadler","game_jersey":"28","goals":"0","assists":"0","pims":"0","player_id":"16426"},
{"name":"Gil Harrison","game_jersey":"29","goals":"0","assists":"0","pims":"0","player_id":"35446"},
{"name":"Kia Tang","game_jersey":"32","goals":"0","assists":"0","pims":"0","player_id":"40555"},
{"name":"Paul Rodriguez","game_jersey":"33","goals":"0","assists":"0","pims":"0","player_id":"26036"},
{"name":"Jim Olson","game_jersey":"4","goals":"0","assists":"0","pims":"0","player_id":"40624"},
{"name":"Kevin Nichols","game_jersey":"5","goals":"0","assists":"0","pims":"0","player_id":"4298"},
{"name":"Armando Barron","game_jersey":"63","goals":"0","assists":"0","pims":"0","player_id":"10379"},
{"name":"Kevin Choboter","game_jersey":"8","goals":"0","assists":"0","pims":"0","player_id":"41423"},
{"name":"Matthew Trinidad","game_jersey":"81","goals":"0","assists":"0","pims":"0","player_id":"7757"}],
"away_players":[{"name":"David Gaul","game_jersey":"10","goals":"0","assists":"0","pims":"0","player_id":"31264"},
{"name":"Andrew Gaul","game_jersey":"17","goals":"0","assists":"0","pims":"0","player_id":"20281"},
{"name":"Chris Smith","game_jersey":"24","goals":"0","assists":"0","pims":"0","player_id":"21205"},
{"name":"Steven Miller","game_jersey":"3","goals":"0","assists":"0","pims":"0","player_id":"35455"},
{"name":"Brian Whiteley","game_jersey":"30","goals":"0","assists":"0","pims":"0","player_id":"25309"},
{"name":"Lysander Diego Martinez","game_jersey":"32","goals":"0","assists":"0","pims":"0","player_id":"40552"},
{"name":"Edwin Mercado","game_jersey":"8","goals":"0","assists":"0","pims":"0","player_id":"13947"},
{"name":"Daniel Gaul","game_jersey":"86","goals":"0","assists":"0","pims":"0","player_id":"24942"},
{"name":"Ross Giordano","game_jersey":"9","goals":"0","assists":"0","pims":"0","player_id":"20870"},
{"name":"Ronald Nielsen","game_jersey":"91","goals":"0","assists":"0","pims":"0","player_id":"20344"}]}




