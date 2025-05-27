import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['query', 'submit'];
  static values = { url: String };

  // Actions

  getAutocomplete() {
    if (this.queryTarget.value.length >= 3) {
      this.element.action = this.setQueryUrl();
      this.submitTarget.click();
    }
  }

  getSearch(e) {
    e.preventDefault();
    window.location.href = this.setQueryUrl();
  }

  // Utilities

  setQueryUrl() {
    const url = this.urlValue;
    const query = this.queryTarget.value;
    const queryUrl = `${url}?query=${query}`;
    return queryUrl;
  }
}