import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['query', 'submit', 'form', 'autocomplete'];
  static values = { url: String };

  // Actions

  getAutocomplete() {
    const query = this.queryTarget.value.trim()
    if (query.length >= 3) {
      fetch(`/welcome/search?query=${encodeURIComponent(query)}&format=json`)
        .then(response => response.json())
        .then(data => {
          this.updateAutocomplete(data)
        })
    } else {
      this.autocompleteTarget.innerHTML = ''
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

  toggle(event) {
    event.stopPropagation();
    const form = document.querySelector('.SearchForm');
    if (form) {
      form.classList.toggle('is-visible');
      if (form.classList.contains('is-visible')) {
        this.queryTarget.focus();
      }
    }
  }

  // Закрытие только по кнопке или overlay
  close(event) {
    event?.stopPropagation();
    const form = document.querySelector('.SearchForm');
    if (form) {
      form.classList.remove('is-visible');
    }
  }

  updateAutocomplete(results) {
    this.autocompleteTarget.innerHTML = results.map(result => `
      <div class="SearchResult" data-action="click->search#selectResult">
        ${result.title}
      </div>
    `).join('')
  }

  selectResult(event) {
    const result = event.target.textContent
    this.queryTarget.value = result
    this.autocompleteTarget.innerHTML = ''
    this.formTarget.submit()
  }
}