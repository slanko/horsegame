using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class tutorialTreeGrowScript : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] Animator anim;

    public void growTheTree()
    {
        anim.SetTrigger("GROW");
    }
}
