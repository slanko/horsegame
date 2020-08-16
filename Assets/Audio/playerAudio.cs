using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class playerAudio : MonoBehaviour
{
    AudioSource aud;
    godScript GOD;
    public AudioClip[] footstepSounds;
    // Start is called before the first frame update
    void Start()
    {
        aud = GetComponent<AudioSource>();
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
    }

    // Update is called once per frame
    void Update()
    {
        aud.volume = GOD.audioVolume;
    }

    public void playFootStepSound()
    {
        aud.PlayOneShot(footstepSounds[Random.Range(0, footstepSounds.Length)]);
    }
}
