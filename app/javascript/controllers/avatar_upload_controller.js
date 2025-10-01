import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
  }

  handleFileSelect(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      
      reader.onload = (e) => {
        this.updatePreview(e.target.result)
      }
      
      reader.readAsDataURL(file)
    }
  }

  updatePreview(imageSrc) {
    const preview = document.getElementById('avatar-preview')
    if (preview) {
      if (preview.tagName === 'DIV') {
        const img = document.createElement('img')
        img.src = imageSrc
        img.className = 'O_ProfileEditAvatar'
        img.alt = 'Аватар профиля'
        img.id = 'avatar-preview'
        preview.parentNode.replaceChild(img, preview)
      } else {
        preview.src = imageSrc
      }
    }
  }
}
