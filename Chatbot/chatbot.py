import discord
import requests

DISCOR_BOT_TOKEN = 'MTE4MjQxOTI1ODkyMDE2MTQyNA.GDVL-d.3F-oDwva_aHJsODeM5i8op5hYrpAaHW_W5AQTE'
RASA_INTERPRETER_URL = "http://localhost:5005/webhooks/rest/webhook"



class MyClient(discord.Client):
    async def on_ready(self):
        print("Bot is ready for use")
        print(f"Logged in as {client.user}")


    async def on_message(self, message):
        print("start")
        # Ignore messages sent by the bot itself
        if message.author == client.user:
            return
        
        if message == '!help':
            try:
                await message.channel.send(f"I don't have any commands just talk to me.")
            except Exception as e:
                print(e)  

        # Send the message to the Rasa server for interpretation
        response = rasa_interprete(message.content)

        # Get the intent and confidence from the response
        # intent = response["intent"]["name"]
        # confidence = response["intent"]["confidence"]

        #  Send the response back to the Discord chat
        try:
            print("sending message")
            # await message.channel.send(f"{message.author.mention}: Rasa interpreted your message as '{intent}' with confidence {confidence}")
            await message.channel.send(response)
        except Exception as e:
            print(e)        

# async def send_message(message, user_message, is_private):

#     payload = {"message": message}
#     response = requests.post(rasa_url, json=payload)

#     try:
#         response = responses.get_response(user_message)
#         await message.author.send(response)  if is_private else message.channel.send(response)
#     except Exception as e:
#         print(e)



def rasa_interpreter_intent_confidence(message):
    payload = {"message": message}
    response = requests.post(RASA_INTERPRETER_URL, json=payload)
    return response.json()

def rasa_interprete(message):
    data = {"sender": "user", "message": message}
    response = requests.post(RASA_INTERPRETER_URL, json=data)
    response_json = response.json()
    if response_json:
        text = response_json[0].get("text", "")
        return text
    return ""

# def run_discord_bot():
intents = discord.Intents.all()
intents.message_content = True
client = MyClient(intents=intents)
# client = commands.Bot(command_prefix="!", intents=intents)
client.run(DISCOR_BOT_TOKEN)


# async def on_ready():
#     print("Bot is ready for use")
#     print(f"Logged in as {client.user}")


# async def on_message(message):
#     print("start")
#     # Ignore messages sent by the bot itself
#     if message.author == client.user:
#         return
    
#     if message == '!help':
#         try:
#             await message.channel.send(f"I don't have any commands just talk to me.")
#         except Exception as e:
#             print(e)    

    # Send the message to the Rasa server for interpretation
    # response = rasa_interprete(message.content)

    # Get the intent and confidence from the response
    # intent = response["intent"]["name"]
    # confidence = response["intent"]["confidence"]

    #  Send the response back to the Discord chat
    # try:
    #     print("sending message")
    #     # await message.channel.send(f"{message.author.mention}: Rasa interpreted your message as '{intent}' with confidence {confidence}")
    #     await message.channel.send(response)
    # except Exception as e:
    #     print(e)
            


# run_discord_bot()