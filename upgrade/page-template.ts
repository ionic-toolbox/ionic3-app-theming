import { NgModule }						from '@angular/core';
import { IonicPageModule }				from 'ionic-angular';
import { _PAGENAME_Page }				from './_FILENAME_';

@NgModule({
	declarations: [
		_PAGENAME_Page,
	],
	imports: [
		IonicPageModule.forChild(_PAGENAME_Page),
	],
	exports: [
		_PAGENAME_Page
	]
})
export class _PAGENAME_PageModule { }