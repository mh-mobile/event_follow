document.addEventListener("DOMContentLoaded", () => {

  const profile_icon = document.getElementById("js-profile");
  if (profile_icon) {
    const profile_setting = document.getElementById("js-profile-setting");
    profile_icon.addEventListener("click", () => {
      if (profile_setting.style.display === "block") {
        profile_setting.style.display = "none"
      } else {
        profile_setting.style.display = "block"
      }
    })
  }
});

