# Discord Chatbot using rasa

For bot to work you need to go through steps:

-   1. Open terminal and in the project folder use command(rasa bot will answer on calls):  
        ```rasa run --enable-api -m models\20231211-195225-molten-data.tar.gz```
-   2. Open another terminal and run(now rasa bot can work with custom actions):  
        ```rasa run actions```
-   3. Add token to your discord bot in chatbot.py file  
-   4. Open another terminal and run(discord bot will become active):  
        ```py chatbot.py```