using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class tutorialBoolz : MonoBehaviour
{
    public Animator anim;
    public void setFirstBool()
    {
        anim.SetBool("tutorialBool1", true);
    }
    
    public void setSecondBool()
    {
        anim.SetBool("tutorialBool2", true);
    }

    public void setThirdBool()
    {
        anim.SetBool("tutorialBool3", true);
    }

}
