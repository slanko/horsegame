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

    public void setFourthBool()
    {
        anim.SetBool("tutorialBool4", true);
    }

    public void setFifthBool()
    {
        anim.SetBool("tutorialBool5", true);
    }

    public void setSixthBool()
    {
        anim.SetBool("tutorialBool6", true);
    }

    public void setSeventhBool()
    {
        anim.SetBool("tutorialBool7", true);
        PlayerPrefs.SetFloat("tutorialComplete", 1);
    }
}
