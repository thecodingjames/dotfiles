/* 
	Hide Panel (light version & without hot corner)
	Copyright Francois Thirioux 2021
	GitHub contributors: @fthx
	License GPL v3

  Modified to support gnome 45+
*/

import * as Main from 'resource:///org/gnome/shell/ui/main.js';
const Panel = Main.panel;
const Overview = Main.overview;

import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';


export default class HidePanel extends Extension {
    _allAreas() {
      return ['activities', 'quickSettings']
    }

    _applyToAreas(action) {
      this._allAreas.forEach((area) => {
        Panel.statusArea[area][action]();
      })
    }

    _show() {
      this._applyToAreas('show');
      Panel.set_height(this.panel_height);
    }
    
    _hide() {
      this._applyToAreas('hide');
      Panel.set_height(0);
    }

    enable() {
      this.panel_height = Panel.get_height();

      this._hide();

      this.showing = Overview.connect('showing', this._show.bind(this));
      this.hiding = Overview.connect('hiding', this._hide.bind(this));
    }

    disable() {
    	Overview.disconnect(this.showing);
    	Overview.disconnect(this.hiding);

      this._show();
    }
}
