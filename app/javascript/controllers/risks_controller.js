import DualListbox from 'dual-listbox/dist/dual-listbox';
import PageController from './page_controller';

export default class extends PageController {
  static targets = ["container", "listbox"];

  connect() {
    var listbox, select;

    if (this.hasListboxTarget) {
      select = this.listboxTarget;
      return listbox = new DualListbox(select, {
        availableTitle: 'Categorie disponibili',
        selectedTitle: 'Categorie selezionate',
        addButtonText: '>',
        removeButtonText: '<',
        addAllButtonText: '>>',
        removeAllButtonText: '<<'
      });
    }
  }
}