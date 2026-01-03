export const can = {
  manageUsers: (role) => role === "admin",

  viewUser: (viewer, target) => {
    if (viewer.role === "admin") return true;
    if (viewer.role === "teacher" && target.role === "student") {
      return viewer.departmentId === target.departmentId;
    }
    return viewer.uid === target.uid;
  },

  modifyClass: (role) => role === "admin" || role === "teacher",

  createMessage: (role) => role === "admin" || role === "teacher"
};
