import express from "express";
import morgan from "morgan";

const app = express();
app.use(express.json());
app.use(morgan("dev"));

app.get("/", (_req, res) => {
  res.json({ message: "Plexxer backend is running ✅" });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`🚀 Plexxer backend on port ${PORT}`));
