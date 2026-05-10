import { createBrowserRouter } from "react-router";
import Layout from "./components/Layout";
import Home from "./pages/Home";
import Marketplace from "./pages/Marketplace";
import Notes from "./pages/Notes";
import ProductDetail from "./pages/ProductDetail";
import NoteDetail from "./pages/NoteDetail";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Layout,
    children: [
      { index: true, Component: Home },
      { path: "marketplace", Component: Marketplace },
      { path: "marketplace/:id", Component: ProductDetail },
      { path: "notes", Component: Notes },
      { path: "notes/:id", Component: NoteDetail },
    ],
  },
]);
