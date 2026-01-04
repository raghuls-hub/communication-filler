import { signOut } from "firebase/auth";
import { auth } from "../firebase";
import { useNavigate } from "react-router-dom";

export default function LogoutButton() {
  const navigate = useNavigate();

  const handleLogout = async () => {
    await signOut(auth);
    navigate("/login");
  };

  return (
    <button className="bg-red-600 text-white px-4 py-2 rounded" onClick={handleLogout}>
      Logout
    </button>
  );
}
