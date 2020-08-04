using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class stableHorseHelperScript : MonoBehaviour
{
    stableHorseScript sHS;

    private void Start()
    {
        sHS = GetComponentInParent<stableHorseScript>();
    }

    void passThroughDialogue(string stringaling)
    {
        if(stringaling == null || stringaling == "")
        {
            stringaling = sHS.myGreetings[Random.Range(0, sHS.myGreetings.Length)];
        }
        sHS.setMyText(stringaling);
    }

    void clearText()
    {
        sHS.myText.text = "";
    }


}
