import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input', 'autocomplete'];

  autocomplete() {
    const query = this.inputTarget.value.trim();
    
    if (query.length >= 3) {
      this.fetchAutocomplete(query);
    } else {
      this.clearAutocomplete();
    }
  }

  async fetchAutocomplete(query) {
    try {
      const response = await fetch(`/search/autocomplete?query=${encodeURIComponent(query)}`);
      
      if (!response.ok) {
        throw new Error('Ошибка сети');
      }
      
      const results = await response.json();
      this.updateAutocomplete(results);
    } catch (error) {
      this.showError('Ошибка загрузки результатов');
    }
  }

  updateAutocomplete(results) {
    if (results.length === 0) {
      this.autocompleteTarget.innerHTML = '<div class="autocomplete-item">Ничего не найдено</div>';
      return;
    }

    this.autocompleteTarget.innerHTML = results.map(result => `
      <div class="autocomplete-item" data-action="click->search-page#selectResult" data-url="${result.url}">
        <div class="autocomplete-title">${result.title}</div>
        <div class="autocomplete-type">${this.getTypeLabel(result.type)}</div>
      </div>
    `).join('');
  }

  selectResult(event) {
    const resultElement = event.currentTarget;
    const url = resultElement.dataset.url;
    const title = resultElement.querySelector('.autocomplete-title').textContent;
    
    this.inputTarget.value = title;
    this.clearAutocomplete();
    
    if (url) {
      window.location.href = url;
    }
  }

  clearAutocomplete() {
    this.autocompleteTarget.innerHTML = '';
  }

  showError(message) {
    this.autocompleteTarget.innerHTML = `<div class="autocomplete-item autocomplete-error">${message}</div>`;
  }

  getTypeLabel(type) {
    const typeLabels = {
      'Event': 'Событие',
      'Meet': 'Встреча',
      'Community': 'Сообщество'
    };
    return typeLabels[type] || type;
  }
}
