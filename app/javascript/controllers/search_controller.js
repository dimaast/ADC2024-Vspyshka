import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['query'];

  initialize() {
    console.log('Search Controller Initialized')
  }
  connect() {
    console.log('Search Controller Initialized')
  }
  getSearch(e) {
    e.preventDefault();
    const url = this.element.action;
    const query = this.queryTarget.value;
    window.location.href = `${url}?query=${query}`;
  }
}
