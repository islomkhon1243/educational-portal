<template>
  <div class="chatbot-wrapper"> <!-- Single root element -->
    <div class="chatbot-container" v-if="isVisible">
      <div class="chat-header">
        <h3>AI Support Bot</h3>
        <button @click="toggleChat" class="close-button">X</button>
      </div>
      <div class="chat-messages" ref="messages">
        <div v-for="message in messages" :key="message.id" class="message"
             :class="{'user-message': message.from === 'user', 'bot-message': message.from === 'bot'}">
          <p>{{ message.text }}</p>
        </div>
      </div>
      <div class="chat-input">
        <input v-model="userInput" @keyup.enter="sendMessage" placeholder="Type your message..." />
        <button @click="sendMessage">Send</button>
      </div>
    </div>
    <button class="chatbot-toggle" @click="toggleChat">
      Chat with us!
    </button>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      isVisible: false,
      userInput: '',
      messages: []
    };
  },
  methods: {
    toggleChat() {
      this.isVisible = !this.isVisible;
      this.$nextTick(() => {
        if (this.isVisible) {
          this.$refs.messages.scrollTop = this.$refs.messages.scrollHeight;
        }
      });
    },
    sendMessage() {
      if (this.userInput.trim() === '') return;

      this.messages.push({ id: Date.now(), text: this.userInput, from: 'user' });
      this.getBotResponse(this.userInput);
      this.userInput = '';
    },
    async getBotResponse(userMessage) {
      const data = JSON.stringify({
        model: "gpt-4o-mini", // Use the correct model
        messages: [
          { role: "user", content: userMessage }
        ],
        temperature: 0.7
      });

      const config = {
        method: 'post',
        maxBodyLength: Infinity,
        url: 'https://api.openai.com/v1/chat/completions',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer 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` // Ensure your API key is stored correctly
        },
        data: data
      };

      try {
        const response = await axios.request(config);
        const botResponse = response.data.choices[0].message.content.trim(); // Access the content of the response
        this.messages.push({ id: Date.now() + 1, text: botResponse, from: 'bot' });
        this.$nextTick(() => {
          this.$refs.messages.scrollTop = this.$refs.messages.scrollHeight; // Scroll to the latest message
        });
      } catch (error) {
        console.error("Error fetching response from OpenAI:", error);
        this.messages.push({ id: Date.now() + 1, text: "I'm sorry, I couldn't process your request.", from: 'bot' });
      }
    }
  }
};
</script>

<style scoped>
.chatbot-wrapper {
  position: fixed;
  bottom: 20px;
  right: 20px;
}

.chatbot-container {
  border: 1px solid #ccc;
  border-radius: 8px;
  background-color: white;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
}

.chat-header {
  background-color: #4A90E2;
  color: white;
  padding: 10px;
  border-top-left-radius: 8px;
  border-top-right-radius: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.close-button {
  background: transparent;
  border: none;
  color: white;
  cursor: pointer;
}

.chat-messages {
  padding: 10px;
  height: 200px;
  overflow-y: auto;
}

.message {
  margin: 5px 0;
  padding: 8px;
  border-radius: 5px;
}

.user-message {
  background-color: #d1e7dd;
  text-align: right;
}

.bot-message {
  background-color: #f8d7da;
  text-align: left;
}

.chat-input {
  display: flex;
  padding: 10px;
}

.chat-input input {
  flex: 1;
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

.chat-input button {
  margin-left: 10px;
  background-color: #4A90E2;
  color: white;
  border: none;
  padding: 10px;
  border-radius: 5px;
  cursor: pointer;
}

.chatbot-toggle {
  position: fixed;
  bottom: 20px;
  right: 20px;
  background-color: #4A90E2;
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
}
</style>