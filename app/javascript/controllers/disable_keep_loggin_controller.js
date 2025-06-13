import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "password",
    "confirmPassword",
    "keepLogginCheckbox",
  ]

  connect() {
    this.toggleKeepLogginCheckbox()
  }

  toggleKeepLogginCheckbox() {
    const passwordFilled = this.passwordTarget.value.trim() !== ""
    const confirmPasswordFilled = this.confirmPasswordTarget.value.trim() !== ""

    this.keepLogginCheckboxTarget.disabled = !(passwordFilled && confirmPasswordFilled)
  }
}
