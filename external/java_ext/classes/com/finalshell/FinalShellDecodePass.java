package com.finalshell;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Random;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

/**
 * @author jas502n
 */

public class FinalShellDecodePass {
    static int Size = 8;
    static SecureRandom sr;


    public static boolean checkStr(String str) {
        if (str == null) {
            return true;
        } else {
            String s2 = str.trim();
            return "".equals(s2);
        }
    }

    public static String decodePass(String data) throws IOException, Exception {
        if (data == null) {
            return null;
        } else {
            String rs = "";
            if (!checkStr(data)) {
                byte[] buf = (new BASE64Decoder()).decodeBuffer(data);
                byte[] head = new byte[Size];
                System.arraycopy(buf, 0, head, 0, head.length);
                byte[] d = new byte[buf.length - head.length];
                System.arraycopy(buf, head.length, d, 0, d.length);
                byte[] bt = desDecode(d, ranDomKey(head));
                rs = new String(bt, StandardCharsets.UTF_8);
            }

            return rs;
        }
    }

    public static String encodePass(String content) throws Exception {
        byte[] head = generateByte(Size);
        byte[] d = desEncode(content.getBytes(StandardCharsets.UTF_8), head);
        byte[] result = new byte[head.length + d.length];
        System.arraycopy(head, 0, result, 0, head.length);
        System.arraycopy(d, 0, result, head.length, d.length);
        String var1 = (new BASE64Encoder()).encodeBuffer(result);
        String rs = var1.replace("\n", "");
        return rs;
    }

    static byte[] ranDomKey(byte[] head) throws NoSuchAlgorithmException {
        long ks = 3680984568597093857L / (long)(new Random((long)head[5])).nextInt(127);
        Random random = new Random(ks);
        int t = head[0];

        for(int i = 0; i < t; ++i) {
            random.nextLong();
        }

        long n = random.nextLong();
        Random r2 = new Random(n);
        long[] ld = new long[]{(long)head[4], r2.nextLong(), (long)head[7], (long)head[3], r2.nextLong(), (long)head[1], random.nextLong(), (long)head[2]};
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(bos);
        long[] arrayOfLong1 = ld;
        int j = ld.length;

        for(byte b = 0; b < j; ++b) {
            long l = arrayOfLong1[b];

            try {
                dos.writeLong(l);
            } catch (IOException var18) {
                var18.printStackTrace();
            }
        }

        try {
            dos.close();
        } catch (IOException var17) {
            var17.printStackTrace();
        }

        byte[] keyData = bos.toByteArray();
        keyData = md5(keyData);
        return keyData;
    }

    public static byte[] md5(byte[] data) throws NoSuchAlgorithmException {
        return MessageDigest.getInstance("MD5").digest(data);
    }

    static byte[] generateByte(int len) {
        byte[] data = new byte[len];

        for(int i = 0; i < len; ++i) {
            data[i] = (byte)(new Random()).nextInt(127);
        }

        return data;
    }

    public static byte[] desEncode(byte[] data, byte[] head) throws Exception {
        DESKeySpec dks = new DESKeySpec(ranDomKey(head));
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
        SecretKey secretKey = keyFactory.generateSecret(dks);
        Cipher cipher = Cipher.getInstance("DES");
        cipher.init(1, secretKey, sr);
        return cipher.doFinal(data);
    }

    public static byte[] desDecode(byte[] data, byte[] key) throws Exception {
        DESKeySpec dks = new DESKeySpec(key);
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
        SecretKey secretKey = keyFactory.generateSecret(dks);
        Cipher cipher = Cipher.getInstance("DES");
        cipher.init(2, secretKey, sr);
        return cipher.doFinal(data);
    }
}
