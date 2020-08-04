using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class stableHorseScript : MonoBehaviour
{
    Animator anim;

    public Text myText;

    [Multiline(4)]
    public string[] myGreetings;


    private void Start()
    {
        anim = GetComponentInChildren<Animator>();
    }

    private void OnTriggerEnter(Collider other)
    {
       if(other.gameObject.tag == "Player")
        {
            anim.SetBool("inZone", true);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if(other.gameObject.tag == "Player")
        {
            anim.SetBool("inZone", false);
        }
    }

    public void setMyText(string stringy)
    {
        myText.text = stringy;

    }
}
