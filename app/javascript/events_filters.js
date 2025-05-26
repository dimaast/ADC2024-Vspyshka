document.addEventListener("DOMContentLoaded", function() {
    const root = document.getElementById('C_EventFilters');
    if (!root) return;
  
    const baseUrl = root.dataset.byTagUrl;
    const categorySelect = document.getElementById('category_select');
    const tagSelect = document.getElementById('tag_select');
  
    function buildUrl() {
      const category = categorySelect ? categorySelect.value : "";
      const tag = tagSelect ? tagSelect.value : "";
      let params = [];
      if (category) params.push("category=" + encodeURIComponent(category));
      if (tag) params.push("tag=" + encodeURIComponent(tag));
      return baseUrl + (params.length ? "?" + params.join("&") : "");
    }
  
    function redirectToFilters() {
      window.location.href = buildUrl();
    }
  
    if (categorySelect) categorySelect.addEventListener('change', redirectToFilters);
    if (tagSelect) tagSelect.addEventListener('change', redirectToFilters);
});