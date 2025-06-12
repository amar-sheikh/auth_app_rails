import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "password",
    "confirmPassword",
    "logoutCheckbox",
  ]

  connect() {
    console.log('slakalskdjlasjdlaskjdlkj')
    this.toggleLogoutCheckbox()
  }

  toggleLogoutCheckbox() {
    const passwordFilled = this.passwordTarget.value.trim() !== ""
    const confirmPasswordFilled = this.confirmPasswordTarget.value.trim() !== ""

    this.logoutCheckboxTarget.disabled = !(passwordFilled && confirmPasswordFilled)
  }
}
