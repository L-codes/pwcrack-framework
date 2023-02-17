package com.landray.kmss.util;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.security.Key;
import java.security.SecureRandom;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;

public class DESEncrypt {
   private static final String ENCODING = "UTF-8";
   private static final String ALGORITHM_NAME = "DES";
   private static String strDefaultKey = "kmssSecureKey";
   private Cipher encryptCipher;
   private Cipher decryptCipher;

   public DESEncrypt() throws Exception {
      this(strDefaultKey);
   }

   public DESEncrypt(String strKey) throws Exception {
      this(strKey, false);
   }

   /** @deprecated */
   @Deprecated
   public DESEncrypt(String strKey, boolean isRandom) throws Exception {
      this.encryptCipher = null;
      this.decryptCipher = null;
      Key key = null;
      if (!isRandom) {
         key = this.getKey(strKey);
      } else {
         key = this.getRandomKey(strKey);
      }

      this.encryptCipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
      this.encryptCipher.init(1, key);
      this.decryptCipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
      this.decryptCipher.init(2, key);
   }

   private Key getKey(String str) throws Exception {
      DESKeySpec dks = new DESKeySpec(str.getBytes("UTF-8"));
      SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
      return keyFactory.generateSecret(dks);
   }

   private Key getRandomKey(String str) throws Exception {
      KeyGenerator generator = KeyGenerator.getInstance("DES");
      generator.init(new SecureRandom(str.getBytes("UTF-8")));
      return generator.generateKey();
   }

   public byte[] encrypt(byte[] bytes) throws IllegalBlockSizeException, BadPaddingException {
      return this.encryptCipher.doFinal(bytes);
   }

   public byte[] decrypt(byte[] bytes) throws IllegalBlockSizeException, BadPaddingException {
      return this.decryptCipher.doFinal(bytes);
   }

   public InputStream decrypt(InputStream in) throws Exception {
      byte[] b = IOUtils.toByteArray(in);
      return new ByteArrayInputStream(this.decrypt(b));
   }

   public String encryptString(String str) throws Exception {
      return (new String(Base64.encodeBase64(this.encrypt(str.getBytes("UTF-8")), true), "UTF-8")).replaceAll("\n", "");
   }

   public String decryptString(String str) throws Exception {
      return new String(this.decrypt(Base64.decodeBase64(str.getBytes("UTF-8"))), "UTF-8");
   }

   public static void main(String[] args) throws Exception {
      String str = "password";
      DESEncrypt des = new DESEncrypt("kmssAdminKey");
      System.out.println("加密前的字符：" + str);
      String strTmp = des.encryptString(str);
      System.out.println("加密后的字符：" + strTmp);
      System.out.println("解密后的字符：" + des.decryptString(strTmp));
   }
}
