export default (_: any, res: any, next: any) => {
  res.setHeader("X-XSS-Protection", "1; mode=block")
  res.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
  res.setHeader("X-Content-Type-Options", "nosniff")
  res.setHeader("X-Frame-Options", "SAMEORIGIN")
  res.setHeader("X-Download-Options", "noopen")
  next();
};
