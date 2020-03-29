const Discordie = require("discordie");
const Event = Discordie.Events;
const Bot = new Discordie();
const Config = require("./config.json");

var CommandMessage;

Bot.connect({ token: Config.token });

Bot.Dispatcher.on(Event.GATEWAY_READY, e => {
  console.log(`Discord Link bot has started as ${Bot.User.username}`);
});

Bot.Dispatcher.on(Event.MESSAGE_CREATE, e => {
  var msg = e.message
  if(msg.author.bot) return;

  const args = msg.content.slice(Config.prefix.length).trim().split(/ +/g);
  const command = args.shift().toLowerCase();

  CommandMessage = msg

  switch(command) {
    case "link":
      var link_code = args[0]
      var discordid = msg.author.id

      if (link_code) {
        emit("discordlink:linkplayer", discordid, link_code)
      } else {
        msg.reply("No Link Code provided")
      }
    break;
    default:
  }
});


function CompleteLink(id, license) {
  	CommandMessage.channel.sendMessage(`You have successfully linked your FiveM account with the license: ${license} with your Discord account!`)
  	try {
		var guild = Bot.Guilds.find(g => g.name == Config.guild);
		var role = guild.roles.find(r => r.name == Confog.roleName);
		var user = Bot.Users.get(id);
		var member = user.memberOf(guild);

		member.assignRole(role);
	}
	catch (err)
	{
		console.log("Error: Guild Name or Role ID incorrect/not configured in config.json")
	}
}

function LinkFailed(errormsg) {
	CommandMessage.channel.sendMessage(errormsg)
}

on("discordlink:success", (id, license) => {
  CompleteLink(id, license);
});

on("discordlink:failed", (errormsg) => {
	LinkFailed(errormsg);
})
