using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(AudioSource))]
public class micController : MonoBehaviour
{

    float[] spectrum = new float[256];
    float[] spectrum_smt = new float[256];
    byte[] spectrum_byt = new byte[256 * 4];

    Texture2D audiotex;
    AudioSource audiosrc;

    static public void startMic()
    {
        instance.audiosrc.clip = Microphone.Start(null, true, 10, 44100);
        instance.audiosrc.loop = true;
        //instance.audiosrc.volume = 0.0f;
        instance.audiosrc.spatialBlend = 0.0f;
        while (!(Microphone.GetPosition(null) > 0)) { };
        instance.audiosrc.Play();
    }

    static public void endMic()
    {
        Microphone.End(null);
    }

    static public micController instance = null;

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
            //initialzation about audio & mic
            instance.audiosrc = this.GetComponent<AudioSource>();
            instance.audiotex = new Texture2D(256, 1, TextureFormat.RFloat, false);
            startMic();
        }
    }

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        instance.audiosrc.GetSpectrumData(instance.spectrum, 0, FFTWindow.Rectangular);

        for (int i = 0; i < instance.spectrum.Length; i++)
        {
            instance.spectrum_smt[i] += (instance.spectrum[i] * 256.0f - instance.spectrum_smt[i]) * Time.deltaTime * 4.0f;

            byte[] _byte = System.BitConverter.GetBytes(instance.spectrum_smt[i]);
            instance.spectrum_byt[i * 4 + 0] = _byte[0];
            instance.spectrum_byt[i * 4 + 1] = _byte[1];
            instance.spectrum_byt[i * 4 + 2] = _byte[2];
            instance.spectrum_byt[i * 4 + 3] = _byte[3];
        }
        instance.audiotex.LoadRawTextureData(instance.spectrum_byt);
        instance.audiotex.Apply();
    }

    static public float[] Spectrum
    {
        get { return instance.spectrum_smt; }
    }

    static public Texture2D SpectrumTexture
    {
        get { return instance.audiotex; }
    }


}
