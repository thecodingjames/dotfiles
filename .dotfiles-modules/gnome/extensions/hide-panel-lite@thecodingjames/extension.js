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
    _show_panel() {
      Panel.set_height(this.panel_height);
    }
    
    _hide_panel() {
      Panel.set_height(0);
    }

    enable() {
      this.panel_height = Panel.get_height();

      this._hide_panel();

      this.showing = Overview.connect('showing', this._show_panel.bind(this));
      this.hiding = Overview.connect('hiding', this._hide_panel.bind(this));
    }

    disable() {
    	Overview.disconnect(this.showing);
    	Overview.disconnect(this.hiding);

      this._show_panel();
    }
}
