Vue.component('message', {
  template: '#message_template',
  data() {
    return {};
  },
  computed: {
    textEscaped() {
      let s = this.template ? this.template : this.templates[this.templateId];

      //This hack is required to preserve backwards compatability
      if (this.templateId == CONFIG.defaultTemplateId
          && this.args.length == 1) {
        s = this.templates[CONFIG.defaultAltTemplateId] //Swap out default template :/
      }

      s = s.replace(/{(\d+)}/g, (match, number) => {
        const argEscaped = this.args[number] != undefined ? this.escape(this.args[number]) : match
        if (number == 0 && this.color) {
          if (this.color == 1) {
            return `<div class=stategained> <b>${argEscaped}</b> ` ;
          }
          if (this.color == 2) {
            return `<div class=tweet> <b>${argEscaped}</b> ` ;
          }
          if (this.color == 3) {
            return `<div class=emergency> <b>${argEscaped}</b> ` ;
          }  
          if (this.color == 4) {
            return `<div class=system> <b>${argEscaped}</b> ` ;
          }  
          if (this.color == 5) {
            return `<div class=smsfrom> <b>${argEscaped}</b> ` ;
          }  
          if (this.color == 6) {
            return `<div class=smsto> <b>${argEscaped}</b> ` ;
          }  
          if (this.color == 7) {
            return `<div class=action> <b>${argEscaped}</b> ` ;
          } 
          if (this.color == 8) {
            return `<div class=pager> <b>${argEscaped}</b> ` ;
          }

          if (this.color == 9) {
            var now = new Date();
            var dob = new Date(this.args.DOB);
            var Fname = this.args.Name;
            var Lname = this.args.Surname;
            var sex = this.args.Sex;
            var identifier = this.args.Identifier;
            var pref = this.args.pref;
            console.log(Fname + Lname)
            // console.log(this.args.Name)
            // console.log(this.args.DOB)

            return `<div class="license">
            <div class="license__state">San Andreas</div>
              <div class="license__signature">${Fname} ${Lname}</div>
              <div class="license__photo license__photo--${sex[0]}"></div>
              <div class="license__row license__row--red license__row--pref">${pref}</div>
              <div class="license__row license__row--red license__row--exp">${dob.getMonth() + 1}/${dob.getDate() + 1}/${now.getFullYear() + 1}</div>
              <div class="license__row license__row--last">${Lname}</div>
              <div class="license__row license__row--first">${Fname}</div>
              <div class="license__row license__row--small license__row--address">123 Fake St<br>Los Santos, GTAV 42069</div>
              <div class="license__row license__row--red license__row--dob">${dob.getMonth() + 1}/${dob.getDate() + 1}/${dob.getFullYear()}</div>
              <div class="license__row license__row--rstr">None</div>
              <div class="license__row license__row--class">C</div>
              <div class="license__row license__row--end">None</div>
              <div class="license__row license__row--small license__row--sex">${sex[0]}</div>
              <div class="license__row license__row--small license__row--hgt">5'-03"</div>
              <div class="license__row license__row--tiny license__row--cref">${identifier}</div>
              <div class="license__row license__row--small license__row--hair">Blonde</div>
              <div class="license__row license__row--small license__row--wgt">210 lb</div>
              <div class="license__row license__row--small license__row--eyes">Green</div>
              <div class="license__row license__row--small license__row--iss">04/01/2019</div>
            </div>`;
          } 

          //color is deprecated, use templates or ^1 etc.
          return `<div class=system> <b>${argEscaped}</b> ` ;
        }

        return argEscaped;
      });
      return this.colorize(s);
    },
  },
  methods: {
    colorizeOld(str) {

    },
    colorize(str) {
      let s = "<span>" + (str.replace(/\^([0-9])/g, (str, color) => `</span><span class="color-white">`)) + "</span>";

      const styleDict = {
        '*': 'font-weight: bold;',
        '_': 'text-decoration: underline;',
        '~': 'text-decoration: line-through;',
        '=': 'text-decoration: underline line-through;',
        'r': 'text-decoration: none;font-weight: normal;',
      };

      const styleRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/em>)/;
      while (s.match(styleRegex)) { //Any better solution would be appreciated :P
        s = s.replace(styleRegex, (str, style, inner) => `<em style="${styleDict[style]}">${inner}</em>`)
      }
      return s.replace(/<span[^>]*><\/span[^>]*>/g, '');
    },
    escape(unsafe) {
      return String(unsafe)
       .replace(/&/g, '&amp;')
       .replace(/</g, '&lt;')
       .replace(/>/g, '&gt;')
       .replace(/"/g, '&quot;')
       .replace(/'/g, '&#039;');
    },
  },
  props: {
    templates: {
      type: Object,
    },
    args: {
      type: Array,
    },
    template: {
      type: String,
      default: null,
    },
    templateId: {
      type: String,
      default: CONFIG.defaultTemplateId,
    },
    multiline: {
      type: Boolean,
      default: false,
    },
    color: { //deprecated
      type: Array,
      default: false,
    },
  },
});
