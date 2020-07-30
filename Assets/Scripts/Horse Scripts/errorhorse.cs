using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class errorhorse : MonoBehaviour
{
    Animator anim;
    characterController cC;
    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
    }

    public void freakIt()
    {
        anim.Play("what the");
    }
}
