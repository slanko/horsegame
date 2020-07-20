using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class horseFunctionsScript : MonoBehaviour
{
    public UnityEvent[] whileTamingFunction;
    public Vector2 tamingEventTimeBounds;
    bool tameAbilityTriggered;
    characterController cC;
    // Start is called before the first frame update
    void Start()
    {
        cC = GameObject.Find("Player").GetComponent<characterController>();

        if (whileTamingFunction[0] == null)
        {
            whileTamingFunction[0] = new UnityEvent();
        }
    }

    private void Update()
    {
        if(cC.currentState == characterController.playerState.TAMING)
        {
            if(tameAbilityTriggered == false)
            {
                doTheThing();
                tameAbilityTriggered = true;
            }
        }
        else
        {
            tameAbilityTriggered = false;
        }
    }

    public void doTheThing()
    {
        if (cC.currentState == characterController.playerState.TAMING)
        {
            Debug.Log("Thing done!!");
            Invoke("doTheThing", Random.Range(tamingEventTimeBounds.x, tamingEventTimeBounds.y));
        }
    }
}
