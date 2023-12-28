# Gun shop using NodeJS and ReactJS

To run shop go through steps:

-   1. Open first terminal and in enter command to run database:  
        ```mongod```
-   2. Open second terminal and run command to start backend server:  
        ```node index.js```
-   3. Open third terminal and run command to start client side:  
        ```npm start```


Notes:
- In project was used node version 20. To prepare your environment use commands in terminal:
    ```nvm install 20```
    ```nvm use 20```
- To show that CORS is working there was added put Add product section. When clicking button 'Add product' request is blocked because put request is not added in CORS allowed methods. 