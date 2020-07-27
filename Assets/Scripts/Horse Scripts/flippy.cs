using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class flippy : MonoBehaviour
{
    Animator anim;
    horseFunctionsScript hFS;
    godScript GOD;
    public float changeAmount;
    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
        hFS = GetComponent<horseFunctionsScript>();
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
    }

    public void flip()
    {
        if (hFS.cC.currentState == characterController.playerState.TAMING)
        {
            anim.SetTrigger("buck");
            GOD.tamingSlider.value = GOD.tamingSlider.value + changeAmount;
            Invoke("flip", Random.Range(hFS.tamingEventTimeBounds.x, hFS.tamingEventTimeBounds.y));
        }
    }
}
