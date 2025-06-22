document.addEventListener("DOMContentLoaded", function() {
    const root = document.getElementById('C_EventFilters');
    if (!root) return;
  
    const categorySelect = document.getElementById('category_select');
    const tagSelect = document.getElementById('tag_select');
    const form = document.getElementById('filters_form');
  
    function submitFilters() {
      if (form) form.requestSubmit();
    }
  
    if (categorySelect) categorySelect.addEventListener('change', submitFilters);
    if (tagSelect) tagSelect.addEventListener('change', submitFilters);
});