// Returns the profile pic URL for a username from a global user map
export function getProfilePicUrl(username) {
  if (!window.USER_PROFILE_PICS) return "https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg";
  return window.USER_PROFILE_PICS[username] || "https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg";
}
