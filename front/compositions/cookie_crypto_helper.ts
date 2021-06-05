import CryptoJS from "crypto-js"

export const useCookieCryptoHelper = () => {
  const encryptCookieValue = (target: string, secretKey: string) => {
    return CryptoJS.AES.encrypt(target, secretKey)
  }

  const decryptCookieValue = (target: string, secretKey: string) => {
    const bytes  = CryptoJS.AES.decrypt(target, secretKey)
    return bytes.toString(CryptoJS.enc.Utf8)
  }

  return {
    encryptCookieValue,
    decryptCookieValue
  }
}
