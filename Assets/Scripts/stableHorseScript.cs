using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class stableHorseScript : MonoBehaviour
{
    public bool tutorialHorse;
    public Animator anim, anim2;
    AudioSource aud;
    public AudioClip[] neighSound;

    public Text myText;
    [Multiline(3)]
    public string[] myDialogue;

    [Multiline(4)]
    public string[] myGreetings;

    private void Start()
    {
        aud = GetComponent<AudioSource>();
        //aud.volume = PlayerPrefs.GetFloat("audioVolume") * 0.5f ;
        if(tutorialHorse == true)
        {
            anim.SetBool("tutorialHorse", true);
            anim2.SetBool("tutorialHorse", true);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
       if(other.gameObject.tag == "Player" && tutorialHorse == false)
        {
                anim.SetBool("inZone", true);
                anim2.SetBool("inZone", true);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if(other.gameObject.tag == "Player" && tutorialHorse == false)
        {
            anim.SetBool("inZone", false);
            anim2.SetBool("inZone", false);
        }
    }

    public void setMyText(string stringy)
    {
        myText.text = stringy;
        aud.PlayOneShot(neighSound[Random.Range(0, neighSound.Length)]);
    }

    public void endTutorial()
    {
        tutorialHorse = false;
        anim.SetBool("tutorialHorse", true);
        anim2.SetBool("tutorialHorse", true);
    }
}
