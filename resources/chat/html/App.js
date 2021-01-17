window.APP = {
  template: '#app_template',
  name: 'app',
  data() {
    return {
      style: CONFIG.style,
      showInput: false,
      showWindow: false,
      suggestions: [],
      templates: CONFIG.templates,
      message: '',
      messages: [],
      oldMessages: [],
      oldMessagesIndex: -1,
      currentSug: [],
      currentSugIndex: 0,
      tempSug: []
    };
  },
  destroyed() {
    clearInterval(this.focusTimer);
    window.removeEventListener('message', this.listener);
  },
  mounted() {
    post('http://chat/loaded', JSON.stringify({}));
    this.listener = window.addEventListener('message', (event) => {
      const item = event.data || event.detail; //'detail' is for debuging via browsers
      if (this[item.type]) {
        this[item.type](item);
      }
    });
  },
  watch: {
    messages() {
      if (this.showWindowTimer) {
        clearTimeout(this.showWindowTimer);
      }
      this.showWindow = true;
      this.resetShowWindowTimer();

      const messagesObj = this.$refs.messages;
      this.$nextTick(() => {
        messagesObj.scrollTop = messagesObj.scrollHeight;
      });
    },
  },
  methods: {
    HUD_CHANGE({ hudtype }) {
      if ( hudtype == 2 ) {
         $(".chat-messages").css("height", "115px");
         $(".chat-messages").css("width", "700px");
         $(".chat-input").css("top", "135px");
         $(".chat-input").css("opacity", "1.0");
      } else if ( hudtype == 1 ) {
        $(".chat-messages").css("height", "340px");
        $(".chat-messages").css("width", "480px");
        $(".chat-input").css("top", "360px");
        $(".chat-input").css("opacity", "1.0");
      } else {
        $(".chat-messages").css("height", "0px");
        $(".chat-messages").css("width", "0px");
        $(".chat-input").css("top", "130px");
        $(".chat-input").css("opacity", "0.2");
      }
    },
    ON_OPEN() {
      this.showInput = true;
      this.showWindow = true;
      if (this.showWindowTimer) {
        clearTimeout(this.showWindowTimer);
      }
      this.focusTimer = setInterval(() => {
        if (this.$refs.input) {
          this.$refs.input.focus();
        } else {
          clearInterval(this.focusTimer);
        }
      }, 100);
    },
    ON_MESSAGE({ message }) {
      this.messages.push(message);
    },
    ON_CLEAR() {
      this.messages = [];
      this.oldMessages = [];
      this.oldMessagesIndex = -1;
    },
    ON_SUGGESTION_ADD({ suggestion }) {
      if (!suggestion.params) {
        suggestion.params = []; //TODO Move somewhere else
      }
      this.suggestions.push(suggestion);
    },
    ON_SUGGESTION_REMOVE({ name }) {
      this.suggestions = this.suggestions.filter((sug) => sug.name !== name)
    },
    ON_TEMPLATE_ADD({ template }) {
      if (this.templates[template.id]) {
        this.warn(`Tried to add duplicate template '${template.id}'`)
      } else {
        this.templates[template.id] = template.html;
      }
    },
    ON_CLOSE_CHAT() {
      this.hideInput(true)
    },
    warn(msg) {
      this.messages.push({
        args: [msg],
        template: '^3<b>CHAT-WARN</b>: ^0{0}',
      });
    },
    clearShowWindowTimer() {
      clearTimeout(this.showWindowTimer);
    },
    resetShowWindowTimer() {
      this.clearShowWindowTimer();
      this.showWindowTimer = setTimeout(() => {
        if (!this.showInput) {
          this.showWindow = false;
        }
      }, CONFIG.fadeTimeout);
    },
    keyUp() {
      this.resize();
    },
    keyDown(e) {
      if (e.which === 38 || e.which === 40) {
        e.preventDefault();
        this.moveOldMessageIndex(e.which === 38);
        this.currentSug = this.currentSuggestions(true);
        this.resize();
      } else if (e.which == 33) {
        var buf = document.getElementsByClassName('chat-messages')[0];
        buf.scrollTop = buf.scrollTop - 100;
      } else if (e.which == 34) {
        var buf = document.getElementsByClassName('chat-messages')[0];
        buf.scrollTop = buf.scrollTop + 100;
      } else if (e.which == 27) {
        this.resetShowWindowTimer();
      } else if (e.which == 9) {

        this.currentSug = this.currentSuggestions();
        if (this.currentSugIndex > this.currentSug.length-1) {
          this.currentSugIndex = 0;
        }
        if (this.currentSug.length > 0) {
          this.message = this.currentSug[this.currentSugIndex].name
          this.currentSugIndex++;
        }
      }
    },
    moveOldMessageIndex(up) {
      if (up && this.oldMessages.length > this.oldMessagesIndex + 1) {
        this.oldMessagesIndex += 1;
        this.message = this.oldMessages[this.oldMessagesIndex];
      } else if (!up && this.oldMessagesIndex - 1 >= 0) {
        this.oldMessagesIndex -= 1;
        this.message = this.oldMessages[this.oldMessagesIndex];
      } else if (!up && this.oldMessagesIndex - 1 === -1) {
        this.oldMessagesIndex = -1;
        this.message = '';
      }
    },
    resize() {
      const input = this.$refs.input;
      input.style.height = '5px';
      input.style.height = `${input.scrollHeight + 2}px`;
    },
    send(e) {
      if (e.shiftKey) {
        this.message += '\n';
        this.resize();
      } else {
        if(this.message !== '') {
          post('http://chat/chatResult', JSON.stringify({
            message: this.message,
          }));
          this.oldMessages.unshift(this.message);
          this.oldMessagesIndex = -1;
          this.hideInput();
        } else {
          this.hideInput(true);
        }
      }
    },
    hideInput(canceled = false) {
      if (canceled) {
        post('http://chat/chatResult', JSON.stringify({ canceled }));
      }
      this.message = '';
      this.showInput = false;
      clearInterval(this.focusTimer);
      this.resetShowWindowTimer();
    },
    currentSuggestions(clear=false) {
      if (this.message === '') {
        return [];
      }
      const currentSuggestions = this.suggestions.filter((s) => {
        if (!s.name.startsWith(this.message)) {
          const suggestionSplitted = s.name.split(' ');
          const messageSplitted = this.message.split(' ');
          for (let i = 0; i < messageSplitted.length; i += 1) {
            if (i >= suggestionSplitted.length) {
              return i < suggestionSplitted.length + s.params.length;
            }
            if (suggestionSplitted[i] !== messageSplitted[i]) {
              return false;
            }
          }
        }
        return true;
      }).slice(0, CONFIG.suggestionLimit);

      currentSuggestions.forEach((s) => {
        // eslint-disable-next-line no-param-reassign
        s.disabled = !s.name.startsWith(this.message);

        s.params.forEach((p, index) => {
          const wType = (index === s.params.length - 1) ? '.' : '\\S';
          const regex = new RegExp(`${s.name} (?:\\w+ ){${index}}(?:${wType}*)$`, 'g');

          // eslint-disable-next-line no-param-reassign
          p.disabled = this.message.match(regex) == null;
        });
      });
      if (clear === true) {
        this.currentSugIndex = 0;
        this.tempSug = currentSuggestions;
        return currentSuggestions;
      }
      if (currentSuggestions.length == 1) {
        return this.tempSug
      }
      else {
        if (currentSuggestions.length != this.tempSug.length) {
          this.currentSugIndex = 0;
        }
        this.tempSug = currentSuggestions
        return currentSuggestions;
      }
    }
  },
};
