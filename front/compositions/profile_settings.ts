export const useProfileSettings = () => {

  const eventListener = function (event: any) {
    const profile_setting = document.getElementById("js-profile-setting")
    const target = event.target
    if (profile_setting && target.closest(".profile_icon")) {
      if (profile_setting.style.display === "block") {
        profile_setting.style.display = "none"
      } else {
        profile_setting.style.display = "block"
      } 
    } else if (profile_setting && !target.closest(".profile_setting")) {
        profile_setting.style.display = "none"
    }
  }
  const showProfileSettings = () => {
    document.addEventListener(
      "click",
      eventListener, 
      false
    );  
  }

  const hideProfileSettings = () => {
    document.removeEventListener("click", eventListener)
  }

  return {
    showProfileSettings,
    hideProfileSettings
  }
}
