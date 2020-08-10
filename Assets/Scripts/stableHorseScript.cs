using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class stableHorseScript : MonoBehaviour
{
    public Animator anim, anim2;

    public Text myText;
    [Multiline(3)]
    public string[] myDialogue;

    [Multiline(4)]
    public string[] myGreetings;

    private void OnTriggerEnter(Collider other)
    {
       if(other.gameObject.tag == "Player")
        {
            anim.SetBool("inZone", true);
            anim2.SetBool("inZone", true);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if(other.gameObject.tag == "Player")
        {
            anim.SetBool("inZone", false);
            anim2.SetBool("inZone", false);
        }
    }

    public void setMyText(string stringy)
    {
        myText.text = stringy;
    }
}
