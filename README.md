# Discord Link
Welcome to Discord Link, an alternative way of obtaining a users Discord Identifier.

# Installation Instructions for 'discordlink'
### Step 1
- Drag discordlink from the download into your server resources folder

### Step 2
 - Add the line "start discordlink" to your server.cfg, and boot up the server!

# Installation Instructions for 'discordlink_bot'
### Stage 1 - Creating a Discord Bot
#### Step 1
Go to the [Discord Developer Portal](https://discordapp.com/developers/applications/) and press the "New Application" button in the top right corner of the screen. Give it a name like 'Discord Link' and hit "Create"

#### Step 2
Next, press on the 'Bot' tab on the left (has a icon of a puzzle piece before it) and press the "Add Bot" button in the top left.

#### Step 3
Now, press the "OAuth2" button on the left (has a icon of a wrench before it), and then, inside the "Scopes" box, check the item that says "bot". This will then cause a new box to display below, called "Bot Permissions"

#### Step 4
Inside the "Bot Permissions", check the item called "Administrator" in the top right, and then copy the long URL displayed at the bottom of the "Scopes" box, into a new browser tab. This will then guide you through inviting the bot you just made, to your Discord Server.

### Stage 2 - The Bot Config
#### Step 1
Making sure you are on the [Discord Developer Portal](https://discordapp.com/developers/applications/) page, and have your Discord Link application open, go back to the "Bot" tab on the left, and press the Blue "Copy" button underneith the [Click to Reveal Token]() link message.

#### Step 2
Go into the 'discordlink_bot' resource, and open up Config.json. Inside there, fill out all the fields, making sure to paste your Bot Token you just copied, into the value of the "token" key.

#### Step 3
Open up a commmand prompt, and navigate inside of the 'discordlink_bot' folder (i assume you know how to do this), and once inside, type 'npm install discordie --save'. This will install the npm package needed to run the Bot.

#### Step 4
Once this is done, add the 'discordlink_bot' resource to your FiveM server, just like you would any other resource, and you should be good to go!
